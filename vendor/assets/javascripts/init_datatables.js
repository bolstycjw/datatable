$(function () {
  $('table[role="datatable"]').each(function () {
    var el = $(this)
    var table = el.DataTable({
      ajax: {
        url: el.data('url'),
        data: function (d) {
          location.search.substr(1).split('&')
                  .forEach(function (item) {
                    param = item.split('=')
                    d[param[0]] = param[1]
                  })
        }
      }
    })
    if (el.data('select')) initSelectable(el, table)
  })
})
