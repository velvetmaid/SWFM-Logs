const rows = document.querySelectorAll(".autonumber tbody tr");
let number = 1;

rows.forEach((row) => {
  const firstCell = row.querySelector('td[data-header="NO"]');

  if (firstCell) {
    if (!firstCell.hasAttribute("rowspan")) {
      firstCell.textContent = number++;
    } else {
      firstCell.textContent = number;
    }
  }
});

if (firstCell) {
  const prevRow = rows[index - 1];
  const prevRowSpan = prevRow
    ? prevRow.querySelector('td[data-header="NO"][rowspan]')
    : null;

  if (!prevRowSpan) {
    firstCell.textContent = currentNumber;
    currentNumber++;
  } else {
    firstCell.textContent = "";
  }
}
