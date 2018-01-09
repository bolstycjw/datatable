$(function () {
  $('#datatable').each(function () {
    $(this).DataTable({
      processing: true,
      serverSide: true,
      ajax: { url: $(this).data('url') }
    })
  }
})
