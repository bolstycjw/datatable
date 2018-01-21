$(function () {
  $('table[role="datatable"]').each(function () {
    $(this).DataTable({
      ajax: {
        url: $(this).data('url'),
        data: function (d) {
          location.search
            .substr(1)
            .split('&')
            .forEach(function (item) {
              param = item.split('=')
              d[param[0]] = param[1]
            })
        }
      }
    })
  })
})
