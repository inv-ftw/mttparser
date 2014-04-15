class ItemsDatatable
  delegate :params, :h, :link_to, :raw, :number_to_currency, :edit_item_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Item.count,
        iTotalDisplayRecords: items.count,
        aaData: data
    }
  end

  private

  def data
    items.map do |item|
      [
          item.id,
          item.sku,
          item.name,
          item.brand,
          item.price,
          link_to(raw('<i class="fa fa-pencil"></i> ред.'), edit_item_path(item), class: 'btn btn-xs btn-info') +
          link_to(raw('<i class="fa fa-times"></i>'), item_path(item), method: :delete, data: { confirm: 'Удалить?' }, class: 'hint btn btn-xs btn-danger', title: 'Удалить')
       ]
    end
  end

  def items
    @items ||= fetch_items
  end

  def fetch_items
    items = Item.all
    items
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id sku name brand price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end