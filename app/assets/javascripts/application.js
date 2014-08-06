// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-select
//= require turbolinks
//= require chosen-jquery
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap3
//= require dataTables/extras/TableTools
//= require_tree .



var ready;
ready = function () {
    $('form').on('click', '.remove_fields', function(event){
        $(this).prev('input[type=hidden]').val('1');
        $(this).closest('fieldset').hide();
        event.preventDefault();
    });

    $('form').on('click', '.add_fields', function(event) {
        time = new Date().getTime();
        regexp = new RegExp($(this).data('id'), 'g');
        $(this).before($(this).data('fields').replace(regexp, time));
        event.preventDefault();
    });

    $('.hint').tooltip();

    $('.datatable').dataTable( {
        "oLanguage": {
            "sProcessing":   "Подождите...",
            "sLengthMenu":   "_MENU_ записей на страницу",
            "sZeroRecords":  "Записи отсутствуют.",
            "sInfo":         "Записи с _START_ до _END_ из _TOTAL_ записей",
            "sInfoEmpty":    "Записи с 0 до 0 из 0 записей",
            "sInfoFiltered": "(отфильтровано из _MAX_ записей)",
            "sInfoPostFix":  "",
            "sSearch":       "Поиск:",
            "sUrl":          "",
            "oPaginate": {
                "sFirst": "Первая",
                "sPrevious": "",
                "sNext": "",
                "sLast": "Последняя"
            },
            "oAria": {
                "sSortAscending":  ": активировать для сортировки столбца по возрастанию",
                "sSortDescending": ": активировать для сортировки столбцов по убыванию"
            }
        },

        "sPaginationType": "bootstrap"
    });

    $('.ajax_datatable').dataTable( {
        "oLanguage": {
            "sProcessing":   "Подождите...",
            "sLengthMenu":   "_MENU_ записей на страницу",
            "sZeroRecords":  "Записи отсутствуют.",
            "sInfo":         "Записи с _START_ до _END_ из _TOTAL_ записей",
            "sInfoEmpty":    "Записи с 0 до 0 из 0 записей",
            "sInfoFiltered": "(отфильтровано из _MAX_ записей)",
            "sInfoPostFix":  "",
            "sSearch":       "Поиск:",
            "sUrl":          "",
            "oPaginate": {
                "sFirst": "Первая",
                "sPrevious": "",
                "sNext": "",
                "sLast": "Последняя"
            },
            "oAria": {
                "sSortAscending":  ": активировать для сортировки столбца по возрастанию",
                "sSortDescending": ": активировать для сортировки столбцов по убыванию"
            }
        },

        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 100,
        sAjaxSource: $('.ajax_datatable').data('source')
    });

};

$(document).ready(ready);
$(document).on('page:load', ready);
