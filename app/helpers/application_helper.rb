module ApplicationHelper
  def net_payment_terms_options
    options_for_select(
      [
        ['Net20', 'net_terms_net20'],
        ['Net30', 'net_terms_net30'],
        ['Net60', 'net_terms_net60'],
        ['Net90', 'net_terms_net90'],
        ['Net120', 'net_terms_net120'],
        ['Custom', 'net_terms_custom'],
      ]
    )
  end

  def formatted_string(str)
    str.present? ? str : '-'
  end
end
