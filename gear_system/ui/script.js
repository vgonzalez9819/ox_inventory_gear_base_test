let gear = {};
let slots = {};
let items = {};
let rarities = {};
let ui = {};
let features = {};

function applyUIStyles() {
    document.body.style.fontFamily = ui.font || 'Arial';
    document.documentElement.style.setProperty('--bg', ui.backgroundColor || '#1a1a1a');
    document.documentElement.style.setProperty('--text', ui.textColor || '#fff');
    document.documentElement.style.setProperty('--border', ui.borderColor || '#3e8ed0');
    document.documentElement.style.setProperty('--highlight', ui.highlightColor || '#00ff00');
}

function createSlots() {
    const container = document.getElementById('slots');
    container.innerHTML = '';
    Object.entries(slots).forEach(([name, cfg]) => {
        const div = document.createElement('div');
        div.className = 'slot';
        div.dataset.slot = name;
        div.textContent = cfg.label;
        if (features.showTooltipDescriptions && cfg.label) {
            div.title = cfg.label;
        }
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
            const def = items[item.name] || {};
            const el = document.createElement('div');
            el.className = 'item';
            el.textContent = item.label || item.name;
            const rarity = rarities[item.rarity] || {};
            if (rarity.color) el.style.background = rarity.color;
            el.draggable = true;
            el.addEventListener('dragstart', e => {
                e.dataTransfer.setData('slot', slot);
                e.dataTransfer.setData('item', item.name);
            });
            if (features.showStatPreviewOnHover) {
                el.addEventListener('mouseover', e => {
                    showPreview(item.name, e.pageX, e.pageY);
                });
                el.addEventListener('mouseout', hidePreview);
            }
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

function showPreview(itemName, x, y) {
    const preview = document.getElementById('stat-preview');
    const def = items[itemName];
    if (!def) return;
    let html = `<strong>${def.label || itemName}</strong><br>`;
    if (def.stats) {
        for (const [k, v] of Object.entries(def.stats)) {
            html += `${k}: ${v.value}<br>`;
        }
    }
    preview.innerHTML = html;
    preview.style.left = x + 'px';
    preview.style.top = y + 'px';
    preview.style.display = 'block';
}

function hidePreview() {
    const preview = document.getElementById('stat-preview');
    preview.style.display = 'none';
}

document.getElementById('close').addEventListener('click', () => {
    fetch('https://gear_system/close', {method: 'POST'});
});

document.getElementById('gear-toggle').addEventListener('click', () => {
    fetch('https://gear_system/gearToggle', {method: 'POST'});
});

window.addEventListener('message', event => {
    const data = event.data;
    if (data.action === 'open') {
        gear = data.gear || {};
        slots = data.slots || {};
        items = data.items || {};
        rarities = data.rarities || {};
        ui = data.ui || {};
        features = data.features || {};
        applyUIStyles();
        createSlots();
        renderGear();
        const panel = document.getElementById('gear-panel');
        panel.style.top = (ui.positionTop || 200) + 'px';
        panel.style.left = (ui.positionLeft || 50) + 'px';
        panel.classList.add('show');
        const toggle = document.getElementById('gear-toggle');
        if (ui.toggleButton && ui.toggleButton.enabled) {
            toggle.textContent = ui.toggleButton.icon || 'G';
            toggle.style.bottom = (ui.toggleButton.position.bottom || 20) + 'px';
            toggle.style.left = (ui.toggleButton.position.left || 20) + 'px';
            toggle.classList.add('show');
        } else {
            toggle.classList.remove('show');
        }
    } else if (data.action === 'close') {
        document.getElementById('gear-panel').classList.remove('show');
        document.getElementById('gear-toggle').classList.remove('show');
        hidePreview();
    } else if (data.action === 'setGear') {
        gear = data.gear || {};
        renderGear();
    }
});
