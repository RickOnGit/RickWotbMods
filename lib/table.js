#!/usr/bin/env node
const Table = require('cli-table3');

// Leggi i dati passati dallo script Bash
const input = process.argv.slice(2); // Ottieni gli argomenti
const rows = JSON.parse(input[0]);   // Parso i dati JSON

// Configura la tabella
const table = new Table({
  head: ['Avaiable Remodel/s 🗃️', 'Take a look at the remodel/s 👇'], // Intestazioni della tabella
  colWidths: [23, 33],       // Larghezza delle colonne
  wordWrap: true,
  wrapOnWordBoundary: true,
});

// Aggiungi righe alla tabella
rows.forEach(row => {
  table.push([row.model, row.source]);
});

// Stampa la tabella
console.log(table.toString());
