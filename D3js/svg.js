var bars = document.querySelector(".c3-chart-bars");
var bbox = bars.getBBox();
var dot = document.createElementNS("http://www.w3.org/2000/svg", "circle");
dot.setAttribute('cx', bbox.x);
dot.setAttribute('cy', bbox.y + 0.5*bbox.height);
dot.setAttribute('r', "4");
dot.setAttribute('style', "stroke: black; fill: black");
bars.appendChild(dot);
