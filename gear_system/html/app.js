const container = document.getElementById('gear-container');
const slotsDiv = document.getElementById('gear-slots');
const closeBtn = document.getElementById('close-btn');

closeBtn.addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/close`, {method: 'POST', body: '{}'});
});

window.addEventListener('message', (e) => {
    const data = e.data;
    if (data.action === 'open') {
        buildSlots(data.slots, data.gear);
        container.classList.remove('hidden');
    } else if (data.action === 'update') {
        updateSlots(data.gear);
    }
});

function buildSlots(slots, gear) {
    slotsDiv.innerHTML = '';
    slots.forEach(slot => {
        const el = document.createElement('div');
        el.className = 'slot';
        el.dataset.slot = slot;
        el.draggable = true;
        el.textContent = gear[slot] || slot;
        el.addEventListener('dragstart', (ev) => {
            ev.dataTransfer.setData('text', slot);
        });
        el.addEventListener('dragover', (ev) => ev.preventDefault());
        el.addEventListener('drop', (ev) => {
            ev.preventDefault();
            const from = ev.dataTransfer.getData('text');
            const to = slot;
            fetch(`https://${GetParentResourceName()}/equip`, {
                method: 'POST',
                body: JSON.stringify({from, to})
            });
        });
        el.addEventListener('contextmenu', (ev) => {
            ev.preventDefault();
            fetch(`https://${GetParentResourceName()}/unequip`, {
                method: 'POST',
                body: JSON.stringify({slot})
            });
        });
        slotsDiv.appendChild(el);
    });
}

function updateSlots(gear) {
    document.querySelectorAll('.slot').forEach(el => {
        const slot = el.dataset.slot;
        el.textContent = gear[slot] || slot;
    });
}
