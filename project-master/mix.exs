defmodule Project.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:distillery, "~> 1.5.5", runtime: false},
      {:earmark, "~> 1.3", only: :dev},
      {:ex_doc, "~> 0.20.2", only: :dev},
    ]
  end
end
