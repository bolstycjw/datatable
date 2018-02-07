initSelectable = function (el, table) {
  function initSelectInfo() {
    $('.dataTables_info', table.table().container())
      .append('<span class="select-info"><span class="select-item"></span></span>')
  }

  function updateSelectInfo() {
    var rowIds = el.data('selected') || []
    var selectInfo = $('.select-info .select-item:first-child', table.table().container())
    selectInfo.html(rowIds.length + ' rows selected')
  }

  $('.row:eq(0)', table.table().container()).after(
    '<div class="row">' +
    '<div class="col-sm-12 col-md-6"></div>' +
    '<div class="col-sm-12 col-md-6 text-right"></div>' +
    '</div>'
  )

  new $.fn.dataTable.Buttons(table, {
    name: 'utility',
    buttons: ['selectAll', 'selectNone']
  })

  new $.fn.dataTable.Buttons(table, {
    name: 'actions',
    buttons: $.map(el.data('actions'), function (action) {
      console.log(action)
      return {
        text: action.name,
        init: function(api, node, config) {
          if (action.class) {
            $(node).removeClass()
            $(node).addClass(action.class)
          }
        },
        action: function (e, dt, node, config) {
          var ids = $.map(el.data('selected'), function (rowId) {
            return rowId.replace('#row-', '')
          })
          $.ajax(action.path, {
            headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
            method: 'POST',
            data: {
              ids: ids
            }
          }).done(function (data) {
            dt.ajax.reload()
          })
        }
      }
    })
  })

  table.buttons('utility', null).containers().appendTo(
    $('.row:eq(1) .col-md-6:eq(0)', table.table().container())
  )
  table.buttons('actions', null).containers().appendTo(
    $('.row:eq(1) .col-md-6:eq(1)', table.table().container())
  )

  table.on('draw', function () {
    initSelectInfo()
    var rowIds = el.data('selected') || []
    table.rows(rowIds).select()
    updateSelectInfo()
  })

  table.on('select deselect', function (e, dt, type, indexes) {
    var rowIds = el.data('selected') || []
    $.each(indexes, function (i, v) {
      var rowId = table.row(v).id(true)
      var position = rowIds.indexOf(rowId)
      if (e.type == 'select') {
        if (!~position) { rowIds.push(rowId) }
      } else {
        if (~position) { rowIds.splice(position, 1) }
      }
    })
    el.data('selected', rowIds)
    updateSelectInfo()
  })
}
