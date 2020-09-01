defmodule PublicareWeb.RepositoryController do
  use PublicareWeb, :controller

  alias Publicare.Projects
  alias Publicare.Projects.Repository

  def index(conn, _params) do
    repositories = Projects.list_repositories()
    render(conn, "index.html", repositories: repositories)
  end

  def new(conn, _params) do
    changeset = Projects.change_repository(%Repository{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"repository" => repository_params}) do
    case Projects.create_repository(repository_params) do
      {:ok, repository} ->
        conn
        |> put_flash(:info, "Repository created successfully.")
        |> redirect(to: Routes.repository_path(conn, :show, repository))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    repository = Projects.get_repository!(id)
    render(conn, "show.html", repository: repository)
  end

  def edit(conn, %{"id" => id}) do
    repository = Projects.get_repository!(id)
    changeset = Projects.change_repository(repository)
    render(conn, "edit.html", repository: repository, changeset: changeset)
  end

  def update(conn, %{"id" => id, "repository" => repository_params}) do
    repository = Projects.get_repository!(id)

    case Projects.update_repository(repository, repository_params) do
      {:ok, repository} ->
        conn
        |> put_flash(:info, "Repository updated successfully.")
        |> redirect(to: Routes.repository_path(conn, :show, repository))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", repository: repository, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    repository = Projects.get_repository!(id)
    {:ok, _repository} = Projects.delete_repository(repository)

    conn
    |> put_flash(:info, "Repository deleted successfully.")
    |> redirect(to: Routes.repository_path(conn, :index))
  end
end
