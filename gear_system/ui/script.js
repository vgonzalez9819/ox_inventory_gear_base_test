let gear = {};
let slots = {};

function createSlots() {
    const container = document.getElementById('slots');
    container.innerHTML = '';
    Object.entries(slots).forEach(([name, cfg]) => {
        const div = document.createElement('div');
        div.className = 'slot';
        div.dataset.slot = name;
        div.textContent = cfg.label;
        div.addEventListener('dragover', e => {
            e.preventDefault();
            div.classList.add('dragover');
        });
        div.addEventListener('dragleave', () => div.classList.remove('dragover'));
        div.addEventListener('drop', e => {
            e.preventDefault();
            div.classList.remove('dragover');
            const item = e.dataTransfer.getData('item');
            if (item) sendEquip(name, item);
        });
        container.appendChild(div);
    });
}

function renderGear() {
    document.querySelectorAll('.slot').forEach(s => {
        const slot = s.dataset.slot;
        s.innerHTML = `<strong>${slots[slot].label}</strong>`;
        const item = gear[slot];
        if (item) {
            const label = item.label || item;
            const name = item.name || item;
            const el = document.createElement('div');
            el.className = 'item';
            el.textContent = label;
            if (item.color) el.style.background = item.color;
            el.draggable = true;
            el.addEventListener('dragstart', e => {
                e.dataTransfer.setData('slot', slot);
                e.dataTransfer.setData('item', name);
            });
            s.appendChild(el);
        }
    });
}

function sendEquip(slot, item) {
    fetch(`https://gear_system/equip`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({slot, item})
    });
}

function sendUnequip(slot) {
    fetch(`https://gear_system/unequip`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({slot})
    });
}

document.getElementById('close').addEventListener('click', () => {
    fetch('https://gear_system/close', {method: 'POST'});
});

window.addEventListener('message', event => {
    const data = event.data;
    if (data.action === 'open') {
        gear = data.gear || {};
        slots = data.slots || {};
        createSlots();
        renderGear();
        const panel = document.getElementById('gear-panel');
        panel.style.top = data.pos.top + 'px';
        panel.style.left = data.pos.left + 'px';
        panel.classList.add('show');
    } else if (data.action === 'close') {
        document.getElementById('gear-panel').classList.remove('show');
    } else if (data.action === 'setGear') {
        gear = data.gear || {};
        renderGear();
    }
});
