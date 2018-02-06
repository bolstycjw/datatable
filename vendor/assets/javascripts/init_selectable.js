initSelectable = function (el, table) {
  function initSelectInfo() {
    var tableWrapper = el.closest('.dataTables_wrapper')
    tableWrapper
      .find('.dataTables_info')
      .append(
        '<span class="select-info"><span class="select-item"></span></span>'
      )
  }

  function updateSelectInfo() {
    var rowIds = el.data('selected') || []
    var tableWrapper = el.closest('.dataTables_wrapper')
    var selectInfo = tableWrapper.find('.select-info .select-item:first-child')
    selectInfo.html(rowIds.length + ' rows selected')
  }

  table.on('draw', function () {
    initSelectInfo(el)
    var rowIds = el.data('selected') || []
    table.rows(rowIds).select()
    updateSelectInfo(el)
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
    updateSelectInfo(el)
  })
}
