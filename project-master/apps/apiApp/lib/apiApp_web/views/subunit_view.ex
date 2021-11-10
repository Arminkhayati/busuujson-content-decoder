defmodule ApiAppWeb.SubunitView do
    use ApiAppWeb, :view

    def render("show.json", %{subunit: lesson})do
      %{subunit: lesson}
    end

end
