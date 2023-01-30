function refreshCCFeeValue() {
  let fee = $('#vendor_payment_methods_cc_fees').val().trim();
  if (fee == '') {
    $('#payment-methods-cc-value').text('');
  } else {
    if ($('#vendor_payment_methods_cc_type').val() == 'fee') {
      $('#payment-methods-cc-value').text('($' + fee + ')');
    } else {
      $('#payment-methods-cc-value').text('(' + fee + '%)');
    }
  }
}

$(document).ready(function() {
  $('#vendor_net_payment_terms').on('change', function() {
    $('#net-terms-custom').toggleClass('d-none', $(this).val() != 'net_terms_custom')
  })
  $('#vendor_payment_methods_cc').on('change', function() {
    $('#payment-methods-cc').toggleClass('d-none', !$(this).is(':checked'))
  })
  $('#vendor_third_shipping').on('change', function() {
    $('#vendor_third_shipping_fee_section, #third_shipping_fee-value').toggleClass('d-none', !$(this).is(':checked'))
  })
  $('#vendor_third_shipping').trigger('change')
  $('#vendor_third_shipping_fee').on('change', function() {
    $('#third_shipping_fee-value').text('($' + $(this).val() + ')')
  })
  $('#vendor_dropship_fee_per_item_per_location').on('change', function() {
    $('#dropship_fee_per_item_per_location-value').text('($' + ($(this).val() || 0) + ')')
  })
  $('#vendor_payment_methods_custom').on('change', function() {
    $('#payment-methods-custom').toggleClass('d-none', !$(this).is(':checked'))
  })
  $('#vendor_net_terms_custom').on('change', function() {
    // $('#vendor_custom_net_term_description').toggleClass('d-none', $(this).val() != 'Other')
  })
  $('#vendor_company_type').on('change', function() {
    $('#vendor_company_type_custom').toggleClass('d-none', $(this).val() != 'Other')
  })
  $('#vendor_pricing_status').on('change', function() {
    $('#vendor_pricing_status_other').toggleClass('d-none', $(this).val() != 'Other')
  })
  // $('#vendor_order_submission_type').on('change', function() {
  //   $('#order-submission-portal').toggleClass('d-none', $(this).val() != 'order_submission_portal')
  //   $('#order-submission-email').toggleClass('d-none', $(this).val() != 'order_submission_email')
  //   $('#order-submission-comment').toggleClass('d-none', $(this).val() != 'order_submission_other')
  // })
  $('#vendor_assigned_agent').on('change', function() {
    $('#vendor_assigned_agent_name').val($('#vendor_assigned_agent option:checked').attr('data-name'))
    $('#vendor_assigned_agent_email').val($('#vendor_assigned_agent option:checked').attr('data-email'))
  })
  $('#add-sub-brand').on('click', function() {
    var html = $('#sub-brand-template').html();
    html = html.replace(/NESTED_ID/g, $(this).closest('.card-body').find('> .row').length)
    $(this).parent().parent().before(html);
  })
  $('#add-sub-category').on('click', function() {
    var html = $('#sub-category-template').html();
    html = html.replace(/NESTED_ID/g, $(this).closest('.card-body').find('> .row').length)
    $(this).parent().parent().before(html);
  })

  $('#sub-brands').on('click', '.bi-trash', function() {
    $(this).closest('.row').remove();
  })

  $('#vendor_payment_methods_cc_type, #vendor_payment_methods_cc_fees').on('change', function() {
    refreshCCFeeValue();
  })

  $('#vendors-table .toggle-status').on('change', function() {
    $.ajax({
      method: 'GET',
      url: '/suppliers/' + $(this).closest('td').attr('data-id') + '/status',
      data: {
        status: $(this).is(':checked')
      },
      dataType: 'script'
    });
  })

  $('#lead-time-settings #add-lead-time').on('click', function() {
    var html = $('#lead-time-template').html();
    html = html.replace(/NESTED_ID/g, $('#lead-time-settings .lead-time-row').length)
    $(this).closest('.row').before(html);
  })

  $('#lead-time-settings').on('click', '.bi-trash', function() {
    if ($(this).closest('.lead-time-row').find('.destroy').length > 0) {
      $(this).closest('.lead-time-row').addClass('d-none');
      $(this).closest('.lead-time-row').find('.destroy').val('true');
    } else {
      $(this).closest('.lead-time-row').remove();
    }
  })
})
