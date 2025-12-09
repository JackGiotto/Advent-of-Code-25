const fs = require('fs');
const data = fs.readFileSync('input.txt', 'utf8').trim().split(/\r?\n/);

const numbers = data.slice(0, -1).map(line =>
	line.trim().split(/\s+/).map(Number)
);

const operations = data[data.length - 1].trim().split(/\s+/);

let count = 0;

for (let i = 0; i < operations.length; i++) {
	const column = numbers.map(row => row[i]);

	if (operations[i] === '+') {
	count += column.reduce((a, b) => a + b, 0);
	}
	else if (operations[i] === '*') {
	count += column.reduce((a, b) => a * b, 1);
	}
}

console.log("part 1: " + count);


// PART 2

const charMatrix = data.slice(0, -1).map(line => line.split(''));
const operationsLine = data[data.length - 1];

let total = 0;
let currentNumbers = [];
let currentOperation = null;

for (let col = charMatrix[0].length - 1; col >= 0; col--) {
	const column = charMatrix.map(row => row[col] || ' ');
	const opChar = operationsLine[col] || ' ';
	const allSpaces = column.every(char => char === ' ');
	if (allSpaces) {
		if (currentNumbers.length > 0 && currentOperation) {
			// console.log(`\nNumbers: ${currentNumbers.join(', ')} with operation ${currentOperation}`);
			let result = 0;
			if (currentOperation === '+') {
				result = currentNumbers.reduce((a, b) => a + b, 0);
				// console.log(`${currentNumbers.join(' + ')} = ${result}`);
			} else if (currentOperation === '*') {
				result = currentNumbers.reduce((a, b) => a * b, 1);
				// console.log(`${currentNumbers.join(' * ')} = ${result}`);
			}
			total += result;
			// console.log(`Total: ${total}`);
		}
		currentNumbers = [];
		currentOperation = null;
	} else {
		const digits = column.filter(char => char !== ' ').join('');
		if (digits) {
			currentNumbers.push(parseInt(digits));
		}
		if (opChar === '+' || opChar === '*') {
			currentOperation = opChar;
		}
	}
}

// console.log(`\nNumbers: ${currentNumbers.join(', ')} with operation ${currentOperation}`);
let result = 0;
if (currentOperation === '+') {
	result = currentNumbers.reduce((a, b) => a + b, 0);
	// console.log(`${currentNumbers.join(' + ')} = ${result}`);
} else if (currentOperation === '*') {
	result = currentNumbers.reduce((a, b) => a * b, 1);
	// console.log(`${currentNumbers.join(' * ')} = ${result}`);
}
total += result;
// console.log(`Total: ${total}`);

console.log("\npart 2: " + total);

