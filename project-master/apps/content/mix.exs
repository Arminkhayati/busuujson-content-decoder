defmodule Content.MixProject do
  use Mix.Project

  def project do
    [
      app: :content,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    check_dirs()
    [
      extra_applications: [:logger, :ecto_sql, :postgrex, :httpoison, :poison, :jason],
      mod: {Content.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:gen_tcp_accept_and_close, "~> 0.1.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:httpoison, "~> 1.5"},
      {:poison, "~> 4.0"},
      {:jason, "~> 1.1"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
    ]
  end

  defp check_dirs()do
    upload_dir = Application.get_env(:content, :uploads_directory)
    if File.exists?(upload_dir)do
      :ok
    else
      File.mkdir_p("#{upload_dir}/video")
      File.mkdir_p("#{upload_dir}/audio")
      File.mkdir_p("#{upload_dir}/image")
      File.mkdir_p("#{upload_dir}/other")
    end
  end
end
