window.App ||= {}
class App.PurchaseOrders extends App.Base

  beforeAction: (action) =>
    return


  afterAction: (action) =>
    return


  index: =>
    return


  show: =>
    $('#complete_order').on 'click', ->
      id = $(this).data('id')

      r = confirm('Are you sure?')
      if r == true
        $.ajax
          method: 'PUT'
          url: '/purchase_orders/' + id + '/complete_draft_order'
          dataType: 'json'
          success: ->
            alert 'Draft order is completed and Shopify order is created'
            location.reload()
            return
          error: ->
            alert 'Draft order cannot be completed'
            return
      return

    $('.accordion-initiator').on 'click', ->
      $(this).toggleClass 'active'
    return


  new: =>
    return


  edit: =>
    return