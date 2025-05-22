let visible = false;
let Config = {};
let slots = {};

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'setVisible') {
        visible = data.state;
        document.getElementById('gearPanel').classList.toggle('visible', visible);
        if (data.config) { Config = data.config; applyConfig(data.config); }
        if (data.slots) loadSlots(data.slots);
    } else if (data.action === 'update') {
        loadSlots(data.slots);
    }
});

document.getElementById('closeBtn').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST', body: '{}' });
});

function applyConfig(cfg) {
    document.documentElement.style.setProperty('--bg', cfg.backgroundColor);
    document.documentElement.style.setProperty('--text', cfg.textColor);
    document.documentElement.style.setProperty('--border', cfg.borderColor);
    document.documentElement.style.setProperty('--highlight', cfg.highlightColor);
}

function loadSlots(data) {
    slots = data;
    const container = document.getElementById('slots');
    container.innerHTML = '';
    Object.keys(cfgSlots()).forEach((slot) => {
        const div = document.createElement('div');
        div.className = 'slot';
        div.dataset.slot = slot;
        div.innerText = data[slot] || '';
        div.addEventListener('dragover', allowDrop);
        div.addEventListener('drop', onDrop);
        container.appendChild(div);
    });
}

function cfgSlots() { return Config.GearSlots || {}; }

function allowDrop(e) { e.preventDefault(); }

function onDrop(e) {
    e.preventDefault();
    const item = e.dataTransfer.getData('item');
    const slot = this.dataset.slot;
    fetch(`https://${GetParentResourceName()}/equipItem`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ item: item, slot: slot })
    });
    this.classList.add('glow');
}
