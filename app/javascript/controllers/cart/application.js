// format price to money
export function formatMoney(price) {
  let integerPart = price.toString().split(".")[0].split("").reverse();
  for (let i = 3; i < integerPart.length; i += 4) {
    integerPart.splice(i, 0, ",");
  }
  let decimalPart = price.toString().split(".")[1];
  decimalPart = decimalPart == undefined ? "" : `.${decimalPart}`;
  return `$${integerPart.reverse().join("")}${decimalPart}`;
}
// 金額字串轉換成純數字 $123,456.78 => 123456.78
export function convertMoneyToNumber(price) {
  return Number(price.split("$")[1].split(",").join(""));
}
