$(function () {
  $("table[role='datatable']").DataTable({
    processing: true,
    serverSide: true,
    responsive: true,
    ajax: { url: $(this).data('url') }
  })
})
