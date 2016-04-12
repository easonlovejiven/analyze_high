//= require jquery
//= require jquery_ujs
//= require bootstrap/js/bootstrap.min
//= require components/admin/common/metronic
//= require components/admin/common/layout
//= require components/admin/common/index
//
//
//
//= require_self



$(function() {
    var el = $('body');


    Metronic.init(); // init metronic core componets
    Layout.init(); // init layout
    Demo.init(); // init demo features
    ComponentsPickers.init(); // init date-picker
});
