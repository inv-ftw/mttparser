#encoding: utf-8
class ResultsDatatable
  delegate :params, :h, :link_to, :raw, :target, :round, to: :@view

  def initialize(view, url)
    @view = view
    @url = url
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Result.count,
        iTotalDisplayRecords: results.count,
        aaData: data
    }
  end

  private

  def data
    results.map do |result|
      [
          result.item.sku,
          result.item.name,
          result.item.brand,
          link_to(result.shop.name, "http://#{result.shop.name}", target: '_blank'),
          (result.item.price * result.ex_rate).round(2).to_s +
              '<span class="hint" data-placement="right" title="Курс $: ' +
              result.ex_rate.to_s + '"> грн.</span>',
          result.current_price ? result.current_price.round(2).to_s + ' грн.' : '-',
          result.price_diff && !diff(result).nil? && diff(result) >=0 ? diff(result).round(2).to_s + '%': '-'
      ]
    end
  end

  def diff(result)
    (((result.item.price*result.ex_rate - result.current_price).to_f/(result.item.price*result.ex_rate).to_f)*100) if result.current_price
  end

  def results
    results ||= fetch_results
  end

  def fetch_results
    url_params = @url.split('?').last
    par = CGI::parse(url_params)

    results = Result.all#.order('updated_at DESC')

    conditions = {}
    conditions[:item_id] = par['item'].first unless par['item'].first.blank?
    conditions[:shop_id] = par['shop'].first unless par['shop'].first.blank?
    results = results.where(conditions)
    results = results.joins(:item).where(items: {brand: par['brand'].first}) if par['brand'].first.present?

    results = results.page(page).per_page(per_page)

    if params[:sSearch].present?
      results = results.joins(:item).where("sku like :search or name like :search or brand like :search", search: "%#{params[:sSearch]}%")
    end
    results
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[sku name brand]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end