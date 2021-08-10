defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir iarek"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(u, p) do
    "https://api.github.com/repos/#{u}/#{p}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, body}
  end
end
