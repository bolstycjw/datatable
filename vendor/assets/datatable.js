$(function () {
  $('#datatable').DataTable({
    processing: true,
    serverSide: true,
    ajax: { url: $(this).data('url') }
  })
})
