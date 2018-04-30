var chart = c3.generate({
    bindto: '#chart',
    size: { width: 100, height: 200 },
    data: {
        columns: [ ['data1', 40], ['data2', 60] ],
        type: 'bar',
        groups: [ ['data1', 'data2'] ]
    },
    axis: {
        x: { show: false },
        y: { show: false }
    },
    legend: { show: false }
});
