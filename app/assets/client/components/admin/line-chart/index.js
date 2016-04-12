//= require lodash/lodash
//= require echarts/echarts.min
//= require echarts/themes/macarons
//
//
//= require_self


;
(function($, window, document, undefined) {
    var defaultOption, defaultSerie;
    defaultSerie = {
        name: "",
        type: 'line',
        data: [],
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
    };

    defaultOption = {
        title: {
            text: "默认标题"
        },
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            data: []
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: []
        },
        yAxis: {
            type: 'value'
        },
        series: []
    };


    var LineChart = function(el, opts) {
        this.el = el;
        this.defaults = {};
        this.options = $.extend({}, this.defaults, opts);
    }


    LineChart.prototype = {
        init: function() {
            var me = this,
                el = me.el;

            me.initECharts();
            me.bindEvents();

            window.COMS = window.COMS || [];
            el.attr('data-initialized', 'true');
            el.attr('data-guid', window.COMS.length);
            window.COMS.push(me);

            return me;
        },

        bindEvents: function() {
            var me = this,
                el = me.el;
        },

        initECharts: function() {
            var me = this,
                el = me.el,
                comECharts, option;

            comECharts = echarts.init(el[0], 'macarons');
            option = me.formatOption();

            comECharts.setOption(option);
        },

        formatOption: function() {
            var me = this,
                el = me.el,
                originData = el.data('origin-data'),
                legend = [],
                series = [];

            _.each(originData.series, function(val, i) {
                legend.push(val.name);
            });

            _.each(originData.series, function(val, i) {
                series.push(_.merge(
                    _.cloneDeep(defaultSerie), {
                        name: val.name,
                        data: val.data.split(',')
                    }
                ));
            });

            return _.merge(defaultOption, {
                title: {
                    text: originData.title
                },
                legend: {
                    data: legend
                },
                xAxis: {
                    data: originData.xAxis.split(',')
                },
                series: series
            });
        }
    }

    $.fn.LineChart = function(opts) {
        var com;

        return this.each(function() {
            var elNode = $(this);

            if (elNode.attr('data-initialized') == 'true') {
                return;
            }

            com = new LineChart(elNode, opts);
            com.init();
        });
    }
})(window.jQuery || window.Zepto, window, document);
