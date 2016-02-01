defmodule NetworkTest.Mixfile do
  use Mix.Project

  def project do
    [app: :network_test,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :ssh_pty_ex]]
  end

  defp deps do
    [
      {:ssh_pty_ex, git: "https://github.com/jonnystorm/ssh-pty-elixir.git"}
    ]
  end
end
