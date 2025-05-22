let gear = {};
let slots = {};
let uiCfg = {};
let itemStats = {};
let prevGear = {};

const preview = document.getElementById('preview');
const statsOverlay = document.getElementById('stats-overlay');
const toggleButton = document.getElementById('toggle-button');

function playSound(key) {
    if (!uiCfg.sounds) return;
    const file = uiCfg.sounds[key];
    if (!file) return;
    const audio = new Audio(`./sfx/${file}`);
    audio.volume = uiCfg.sounds.volume || 0.3;
    audio.play();
}

function showPreview(html, x, y) {
    if (!uiCfg.hoverPreview || !uiCfg.hoverPreview.enabled) return;
    preview.style.background = uiCfg.hoverPreview.background || '#111';
    preview.style.color = uiCfg.hoverPreview.textColor || '#fff';
    preview.innerHTML = html;
    preview.style.left = x + 'px';
    preview.style.top = y + 'px';
    preview.style.display = 'block';
}

function hidePreview() {
    preview.style.display = 'none';
}

function calculateStats(set) {
    const res = {};
    Object.values(set).forEach(item => {
        const s = itemStats[item];
        if (!s) return;
        Object.entries(s).forEach(([k, v]) => {
            res[k] = (res[k] || 0) + v;
        });
    });
    return res;
}

function renderOverlay() {
    if (!uiCfg.statOverlay || !uiCfg.statOverlay.enabled) {
        statsOverlay.style.display = 'none';
        return;
    }
    const current = calculateStats(gear);
    let html = '';
    (uiCfg.statOverlay.showStats || []).forEach(st => {
        if (current[st]) html += `${st}: ${current[st]}<br>`;
    });
    statsOverlay.innerHTML = html;
    statsOverlay.style.display = 'block';
}

function createSlots() {
    const container = document.getElementById('slots');
    container.innerHTML = '';
    Object.entries(slots).forEach(([name, cfg]) => {
        const div = document.createElement('div');
        div.className = 'slot';
        if (cfg.locked) div.classList.add('locked');
        div.dataset.slot = name;
        div.textContent = cfg.label;
        div.addEventListener('mouseenter', () => {
            if (cfg.locked && uiCfg.lockedSlotTooltip && uiCfg.lockedSlotTooltip.enabled) {
                let text = uiCfg.lockedSlotTooltip.text || '';
                text = text.replace('{{level}}', cfg.requiredLevel || 0).replace('{{job}}', cfg.requiredJob || '');
                const r = div.getBoundingClientRect();
                showPreview(text, r.right + 5, r.top);
            }
        });
        div.addEventListener('mouseleave', hidePreview);
        div.addEventListener('dragover', e => {
            e.preventDefault();
            div.classList.add('dragover');
            if (uiCfg.dragPreview && uiCfg.dragPreview.enabled) {
                const item = e.dataTransfer.getData('item');
                if (item) {
                    const temp = {...gear, [name]: item};
                    const cur = calculateStats(gear);
                    const nw = calculateStats(temp);
                    let diff = '';
                    Object.keys(nw).forEach(k => {
                        const d = (nw[k] || 0) - (cur[k] || 0);
                        if (d !== 0) diff += `${k}: ${d>0?'+':''}${d}<br>`;
                    });
                    const r = div.getBoundingClientRect();
                    showPreview(diff, r.left, r.bottom + 5);
                }
            }
        });
        div.addEventListener('dragleave', () => {div.classList.remove('dragover'); hidePreview();});
        div.addEventListener('drop', e => {
            e.preventDefault();
            div.classList.remove('dragover');
            const item = e.dataTransfer.getData('item');
            if (item) sendEquip(name, item);
            hidePreview();
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
            const el = document.createElement('div');
            el.className = 'item';
            el.textContent = item;
            el.draggable = true;
            el.addEventListener('dragstart', e => {
                e.dataTransfer.setData('slot', slot);
                e.dataTransfer.setData('item', item);
            });
            el.addEventListener('mouseenter', () => {
                const st = itemStats[item];
                let txt = `<strong>${item}</strong><br>`;
                if (st) Object.entries(st).forEach(([k,v])=>{ txt += `${k}: ${v}<br>`; });
                const r = el.getBoundingClientRect();
                showPreview(txt, r.right + 5, r.top);
            });
            el.addEventListener('mouseleave', hidePreview);
            s.appendChild(el);
        }
        if (prevGear[slot] !== item && uiCfg.equipAnimation && uiCfg.equipAnimation.enabled) {
            const type = uiCfg.equipAnimation.type || 'pulse';
            s.classList.add(type);
            setTimeout(() => s.classList.remove(type), uiCfg.equipAnimation.duration || 300);
            playSound(item ? 'onEquip' : 'onUnequip');
        }
    });
    prevGear = {...gear};
    renderOverlay();
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
        uiCfg = data.ui || {};
        itemStats = data.stats || {};
        createSlots();
        renderGear();
        const panel = document.getElementById('gear-panel');
        panel.style.top = data.pos.top + 'px';
        panel.style.left = data.pos.left + 'px';
        panel.classList.add('show');
        if (uiCfg.toggleButton && uiCfg.toggleButton.enabled) {
            toggleButton.style.bottom = (uiCfg.toggleButton.position.bottom||30) + 'px';
            toggleButton.style.left = (uiCfg.toggleButton.position.left||20) + 'px';
            toggleButton.textContent = uiCfg.toggleButton.icon || '🛡️';
            toggleButton.style.display = 'none';
        }
    } else if (data.action === 'close') {
        document.getElementById('gear-panel').classList.remove('show');
        if (uiCfg.toggleButton && uiCfg.toggleButton.enabled) {
            toggleButton.style.display = 'block';
        }
    } else if (data.action === 'setGear') {
        gear = data.gear || {};
        renderGear();
    } else if (data.action === 'slotLocked') {
        const info = data.info || {};
        let text = uiCfg.lockedSlotTooltip ? uiCfg.lockedSlotTooltip.text : '';
        text = text.replace('{{level}}', info.requiredLevel || 0).replace('{{job}}', info.requiredJob || '');
        showPreview(text, toggleButton.offsetLeft, toggleButton.offsetTop - 20);
        setTimeout(hidePreview, 2000);
    }
});

toggleButton.addEventListener('click', () => {
    fetch('https://gear_system/button', {method: 'POST'});
});

