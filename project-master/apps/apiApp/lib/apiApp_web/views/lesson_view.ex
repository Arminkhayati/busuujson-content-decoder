defmodule ApiAppWeb.LessonView do
  use ApiAppWeb, :view

  def render("index.json", %{lessons: lessons})do
    %{lessons: lessons}
  end

  def render("show.json", %{lesson: lesson})do
    %{lesson: lesson}
  end
  def render("create.json", %{status: :ok})do
    %{status: :done}
  end
end
