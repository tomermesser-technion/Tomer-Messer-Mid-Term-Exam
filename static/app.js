function fetchStatus() {
    fetch('/api/status')
        .then(r => r.json())
        .then(data => {
            document.getElementById('result').textContent = JSON.stringify(data, null, 2);
        });
}
