module SessionsHelper
  def login_tab_active?(tab)
    active_tab = params[:active_tab] || "sign-in"

    if active_tab == tab
      "active"
    else
      ""
    end
  end
end
