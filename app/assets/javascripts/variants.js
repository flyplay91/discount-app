function totalItemMarkupCostRefresh($target) {
  var wholeSaleCost = $target.find('.whole-sale-cost').val();
  var markupCost = $target.find('.markup-cost').val();
  var totalCost;
  if (wholeSaleCost == '' || markupCost == '') {
    $target.find('.item-markup-total').val('');
  } else {
    if ($target.find('.markup-type').val() == 'fixed_markup') {
      totalCost = parseInt(markupCost) + parseFloat(wholeSaleCost);
    } else {
      totalCost = parseFloat(wholeSaleCost) * (100 + parseInt(markupCost)) / 100
      console.log(totalCost);
      totalCost = totalCost.toFixed(2);
    }
    $target.find('.item-markup-total').text(totalCost);
  }
}

$(document).ready(function() {
  $('#variant-content #variant_vendor_id').on('change', function() {
    if($(this).val() == '') {
      $('#variant_vender_sub_brand').html('<option value=""></option>');
    } else {
      $.ajax({
        method: 'GET',
        url: '/suppliers/' + $(this).val() + '/get_sub_brands',
        dataType: 'script'
      });
    }
  })

  $('#variant-content').on('change', '[name="variant[vendor_ids][]"]', function() {
    var $subBrand = $(this).closest('.row').find('[name="variant[vender_sub_brands][]"]');
    if($(this).val() == '') {
      $('#variant_vender_sub_brand').html('<option value=""></option>');
      $subBrand.html('<option value=""></option>');
    } else {
      $.ajax({
        method: 'GET',
        url: '/suppliers/' + $(this).val() + '/get_sub_brands',
        dataType: 'json'
      }).done(function(data) {
        $subBrand.html(data.response);
      });
    }
  })

  $('#add-vendor').on('click', function() {
    var html = $('#vendor-profile-template').html();
    html = html.replace(/NESTED_ID/g, $(this).closest('.card-body').find('.vendor-profile').length)
    $(this).parent().parent().before(html);
  })

  $('#variant-content').on('click', '.vendor-profile .bi-trash', function() {
    $(this).closest('.vendor-profile').remove();
  })

  $('#variant-content #add-price-level').on('click', function() {
    var html = $('#price-level-template').html();
    html = html.replace(/NESTED_ID/g, $('#variant-content .price-level').length)
    $(this).closest('.row').before(html);
  })

  $('#price-levels').on('click', '.bi-trash', function() {
    if ($(this).closest('.price-level').find('.destroy').length > 0) {
      $(this).closest('.price-level').addClass('d-none');
      $(this).closest('.price-level').find('.destroy').val('true');
    } else {
      $(this).closest('.price-level').remove();
    }
  })

  // $('#price-levels').on('change', '.whole-sale-cost, .markup-type, .markup-cost', function() {
  //   totalItemMarkupCostRefresh($(this).closest('.price-level'));
  // })

  $('#pricing-details').on('change', '.cost', function() {
    var labelText = $(this).prev().attr('data-label');
    if ($(this).val()) {
      labelText += ' ($' + $(this).val() + ')';
    }
    $(this).prev().text(labelText);
  })

  $('#price-levels').on('keydown', '.cost', function() {
    // console.log('keydown')
  })

  $('#variant_supplier_type').on('change', function() {
    $('#vendor-details .vendor-profile:nth-child(2)')
      .toggleClass('d-none', $(this).val() == 'single_supplier')
    $('#vendor-details .vendor-profile .col-sm-4:nth-child(3)')
      .toggleClass('d-none', $(this).val() == 'single_supplier');
  })
})
