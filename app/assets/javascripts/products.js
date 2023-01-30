$(document).ready(function() {
  $('.product-item .toggle-variant').on('click', function() {
  	$(this).toggleClass('active');
    $(this).closest('.product-item').find('.variant-items').toggleClass('d-none', !$(this).hasClass('active'))
  })

  $("#file").change(function(){
    $(this).closest('form').submit();


    // var form = $('#upload-form')[0] // Find the <form> element
    // var formData = new FormData(form);
    // var attachment = this.files[0];
    // var formData = new FormData(); 
    // formData.append('attachment', attachment, 'upload.json');
    // form.submit();

    // $.ajax({
    //   method: 'POST',
    //   url: '/products',
    //   dataType: 'script',
    //   data: formData,
    //   contentType: false,
    //   processData: false
    // });
  });

  // $('#uploadModal').modal("show");
})
