class RulesController < AuthenticatedController
  before_action :set_nav
  before_action :set_rule, only: %i(edit update destroy)

  def index
    @rules = Rule.order(created_at: :desc).paginate(page: (params[:page] || 1))
  end

  def new
    @rule = Rule.new.with_defaults
  end

  def create
    rule = Rule.new rule_params
    if rule.save
      redirect_to rules_path
    end
  end

  def edit
    @rule = @rule.with_defaults
  end

  def update
    if @rule.update rule_params
      redirect_to rules_path
    end
  end

  def destroy
    @rule.destroy
    redirect_to rules_path
  end

  private

  def rule_params
    params.require(:rule).permit(
      :name, :status, :rule_type, :select_cat, :filter_cat,
      :shopify_ids, :shop_id,
      conditions_attributes: [
        :id, :_destroy, :condition_type, :condition_str
      ],
      rule_items_attributes: [
        :id, :_destroy, :shopify_id, :shopify_type, :name_1, :name_2
      ],
      price_levels_attributes: [
        :id, :_destroy, :break_number, :discount_amount, :discount_type
      ]
    )
  end

  def set_rule
    @rule = Rule.find(params[:id])
  end

  def set_nav
    @nav_str = 'PO\'s'
  end
end
