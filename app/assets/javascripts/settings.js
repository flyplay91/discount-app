$(document).ready(function() {
  $('#add-staff-account').on('click', function() {
    var html = $('#staff-account-template').html();
    html = html.replace(/NESTED_ID/g, $(this).closest('.card-section').find('> .row').length)
    $(this).parent().parent().before(html);
  })

  $('#add-purchase-order-status').on('click', function() {
    var html = $('#purchase-order-status-template').html();
    html = html.replace(/NESTED_ID/g, $(this).closest('.card-section').find('> .row').length)
    $(this).parent().parent().before(html);
  })

  $('#add-draft-order-status').on('click', function() {
    var html = $('#draft-order-status-template').html();
    html = html.replace(/NESTED_ID/g, $(this).closest('.card-section').find('> .row').length)
    $(this).parent().parent().before(html);
  })

  $('#add-purchase-order-stage').on('click', function() {
    var html = $('#purchase-order-stage-template').html();
    html = html.replace(/NESTED_ID/g, $(this).closest('.card-section').find('> .row').length)
    $(this).parent().parent().before(html);
  })

  $('#add-purchase-order-next-action').on('click', function() {
    var html = $('#purchase-order-next-action-template').html();
    html = html.replace(/NESTED_ID/g, $(this).closest('.card-section').find('> .row').length)
    $(this).parent().parent().before(html);
  })

  $('#add-category').on('click', function() {
    var html = $('#category-template').html();
    html = html.replace(/NESTED_ID/g, $(this).closest('.card-section').find('> .row').length)
    $(this).parent().parent().before(html);
  })

  $('.edit_shop').on('click', '.bi-trash', function() {
    $(this).closest('.row').remove();
  })

  $('#shop_processing_fee').on('change', function() {
    $('#processing-fee-amount').text('$' + $(this).val())
  })

  $('#shop_dropship_fee_charge').on('change', function() {
    $('#dropship-fee-charge-amount').text('$' + $(this).val())
  })

  $('#shop_tax_rate').on('change', function() {
    $('#tax-rate-amount').text($(this).val() + '%')
  })
})
