function refreshSelectedObjects() {
  // var r = confirm("Are you sure to switch rule type?");
  // if (r != true) {
  //   return;
  // }
  var ruleType = $('[name="rule[rule_type]"]:checked').val();
  var html;
  $('#select-products').toggleClass('d-none', true)
  $('#select-variants').toggleClass('d-none', true)
  $('#select-collections').toggleClass('d-none', true)
  switch(ruleType) {
    case 'product':
      html = '<th class="col-md-10">Product Name</th>';
      html += '<th class="col-md-2">Action</th>'
      $('#selected_label').text('Selected Products');
      $('#select-products').toggleClass('d-none', false)
      break;
    case 'variant':
      html = '<th class="col-md-6">Product Name</th>';
      html += '<th class="col-md-4">Variant Name</th>';
      html += '<th class="col-md-2">Action</th>'
      $('#selected_label').text('Selected Variants');
      $('#select-variants').toggleClass('d-none', false)
      break;
    case 'collection':
      html = '<th class="col-md-10">Collection Name</th>';
      html += '<th class="col-md-2">Action</th>'
      $('#selected_label').text('Selected Collections');
      $('#select-collections').toggleClass('d-none', false)
      break;
    default:
      html = '<th class="col-md-10">Product Name</th>';
      html += '<th class="col-md-2">Action</th>'
  }
  $('#selected_objects .selected-objects-section table thead').empty().html(html);
  $('#selected-objects-body').empty();
}

$(document).ready(function() {
  $('#selected-objects-body').on('click', '.object-remove', function() {
    if ($(this).closest('tr').find('.shopify-destroy').length > 0) {
      $(this).closest('tr').addClass('d-none');
      $(this).closest('tr').find('.shopify-destroy').val('true');
    } else {
      $(this).closest('tr').remove();
    }
  })

  var timeoutId;
  $('[name="rule[rule_type]"]').on('change', function() {
    $('#conditional_elements').toggleClass('d-none', $('[name="rule[rule_type]"]:checked').val() === 'cart');
    $('#filter_cat').toggleClass('d-none', $('[name="rule[rule_type]"]:checked').val() !== 'product' || $('[name="rule[rule_type]"]:checked').val() === 'product' && $('[name="rule[select_cat]"]:checked').val() === 'select_all');
    $('#selected_objects').toggleClass('d-none', !($('[name="rule[rule_type]"]:checked').val() !== 'cart' && $('[name="rule[select_cat]"]:checked').val() === 'custom'));
    $('label[for="rule_select_cat"]').html('Select ' + $('[name="rule[rule_type]"]:checked').val() + 's');
    refreshSelectedObjects();
  });
  $('[name="rule[filter_cat]"]').on('change', function() {
    $('#conditions').toggleClass('d-none', $('[name="rule[filter_cat]"]:checked').val() === 'filter_custom');
    $('#select_products').toggleClass('d-none', $('[name="rule[filter_cat]"]:checked').val() !== 'filter_custom');
  });
  $('[name="rule[select_cat]"]').on('change', function() {
    $('#filter_cat').toggleClass('d-none', $('[name="rule[rule_type]"]:checked').val() !== 'product' || $('[name="rule[rule_type]"]:checked').val() === 'product' && $('[name="rule[select_cat]"]:checked').val() === 'select_all');
    $('#selected_objects').toggleClass('d-none', $('[name="rule[select_cat]"]:checked').val() === 'select_all');
  });
  $(document).on('click', '.condition-item .bi-trash', function() {
    if ($(this).closest('.condition-item').find('.destroy').length > 0) {
      $(this).closest('.condition-item').addClass('d-none');
      $(this).closest('.condition-item').find('.destroy').val('true');
    } else {
      $(this).closest('.condition-item').remove();
    }
  });
  $(document).on('click', '#price-levels-body .bi-trash', function() {
    if ($(this).closest('tr').find('.destroy').length > 0) {
      $(this).closest('tr').addClass('d-none');
      $(this).closest('tr').find('.destroy').val('true');
    } else {
      $(this).closest('tr').remove();
    }
  });
  $(document).on('change', '#price-levels-body .discount', function() {
    var $discountPriceGroup = $(this).closest('.discount_price_group');
    var discountPrice = $discountPriceGroup.find('.discount_price').val();
    if (discountPrice) {
      var discountType = $discountPriceGroup.find('select').val();
      switch(discountType) {
        case 'price_discount':
          $(this).closest('tr').find('td:nth-child(4)').html(
            'Get $' + discountPrice + ' Off on each product'
          );
          break;
        case 'fixed_price':
          $(this).closest('tr').find('td:nth-child(4)').html(
            'Get each product for $' + discountPrice
          );
          break;
        case 'percent_discount':
          $(this).closest('tr').find('td:nth-child(4)').html(
            'Get ' + discountPrice + '% Off on each product'
          );
          break;
      }
    }
  })
  $('#add_new_filter').on('click', function() {
    var filled;
    filled = true;
    $('.condition-item input[type="text"]').each(function() {
      if ($(this).val() === null || $(this).val().trim() === '') {
        filled = false;
      }
    });
    if (filled) {
      var html = $('#condition-template').html();
      html = html.replace(/NESTED_ID/g, $('.row.condition-item').length)
      $('.condition-item').last().after(html);
    } else {
      $('.condition-item input').each(function() {
        if ($(this).val() === null || $(this).val().trim() === '') {
          $(this).addClass('valid-error');
        }
      });
    }
    $('.condition-item input').off('change', function() {});
    return $('.condition-item input').on('change', function() {
      return $(this).removeClass('valid-error');
    });
  });

  $('#add-price-level').on('click', function() {
    // var html = $('#price-level-template').html();
    // html = html.replace(/NESTED_ID/g, $('#price-levels-body tr').length)
    // $('#price-levels-body tr').last().after(html);
  })
  $('#productsModal').on('show.bs.modal', function(event) {
    $('#productsModal #search_results').empty();
    $('#productsModal #search_products').val('');
    $.ajax({
      method: 'GET',
      url: '/search_products',
      dataType: 'script'
    });
  });
  timeoutId = 0;
  $('#productsModal #search_products').on('keyup', function() {
    var keyword;
    keyword = $(this).val().trim();
    clearTimeout(timeoutId);
    return timeoutId = setTimeout((function() {
      $('#productsModal #search_results').empty();
      $.ajax({
        method: 'GET',
        url: '/search_products',
        data: {
          keyword: keyword
        },
        dataType: 'script'
      });
    }), 500);
  });
  $('#variantsModal').on('show.bs.modal', function(event) {
    $('#variantsModal #search_results').empty();
    $('#variantsModal #search_products').val('');
    $.ajax({
      method: 'GET',
      url: '/search_variants',
      dataType: 'script'
    });
  });
  $('#collectionsModal').on('show.bs.modal', function(event) {
    $('#collectionsModal #search_results').empty();
    $('#collectionsModal #search_collections').val('');
    $.ajax({
      method: 'GET',
      url: '/search_collections',
      dataType: 'script'
    });
  });
})
