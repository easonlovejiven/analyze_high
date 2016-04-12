//= require jquery
//= require jquery_ujs
//= require bootstrap/js/bootstrap.min
//
//
//= require components/admin/common/metronic
//= require components/admin/common/layout
//= require components/admin/common/index
//= require components/admin/line-chart/index
//
//
//= require_self



$(function() {
    var el = $('body');


    Metronic.init(); // init metronic core componets
    Layout.init(); // init layout
    Demo.init(); // init demo features
    // ComponentsPickers.init(); // init date-picker

    // // 基于准备好的dom，初始化echarts实例
    // var myChart = echarts.init(el.find('.com-echarts')[0]);

    // // 指定图表的配置项和数据
    // var option = {
    //     title: {
    //         text: 'ECharts 入门示例'
    //     },
    //     tooltip: {},
    //     legend: {
    //         data: ['销量']
    //     },
    //     xAxis: {
    //         data: ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]
    //     },
    //     yAxis: {},
    //     series: [{
    //         name: '销量',
    //         type: 'bar',
    //         data: [5, 20, 36, 10, 10, 20]
    //     }]
    // };

    // // 使用刚指定的配置项和数据显示图表。
    // myChart.setOption(option);


    el.find('.com-line-chart').LineChart();

    // 初始化echarts
    el.find('.com-echarts').each(function(i, node) {
        var elEcharts = el.find(node),
            comEcharts = echarts.init(node, 'macarons'),
            originData = elEcharts.data('origin-data'),
            option = {};


        console.log(originData);
        option = {
            title: {
                text: originData.title
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                data: [originData.series[0].name, , originData.series[1].name, ]
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: originData.xAxis.split(',')
            },
            yAxis: {
                type: 'value'
            },
            series: [{
                name: originData.series[0].name,
                type: 'line',
                data: originData.series[0].data.split(','),
                markPoint: {
                    data: [
                        { type: 'max', name: '最大值' },
                        { type: 'min', name: '最小值' }
                    ]
                },
                markLine: {
                    data: [
                        { type: 'average', name: '平均值' }
                    ]
                }
            }, {
                name: originData.series[1].name,
                type: 'line',
                data: originData.series[1].data.split(','),
                markPoint: {
                    data: [
                        { type: 'max', name: '最大值' },
                        { type: 'min', name: '最小值' }
                    ]
                },
                markLine: {
                    data: [
                        { type: 'average', name: '平均值' }
                    ]
                }
            }]
        };


        comEcharts.setOption(option);
    });
});
