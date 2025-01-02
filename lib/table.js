const Table = require('cli-table3');  // Importa la libreria cli-table3

// Leggi i dati passati dallo script Bash
const input = process.argv.slice(2); // Ottieni gli argomenti
const rows = JSON.parse(input[0]);   // Parso i dati JSON

// Configura la tabella
const table = new Table({
  head: ['Avaiable Remodel/s 🗃️', 'Take a look at the remodel/s 👇'],
  colWidths: [23, 37],  // Impostando una larghezza maggiore per la colonna dei link
  wordWrap: true,
});

// Aggiungi righe alla tabella
rows.forEach(row => {
  table.push([row.model, row.source]);
});

// Stampa la tabella
console.log(table.toString());
