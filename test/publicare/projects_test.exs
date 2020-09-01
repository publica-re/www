defmodule Publicare.ProjectsTest do
  use Publicare.DataCase

  alias Publicare.Projects

  describe "repositories" do
    alias Publicare.Projects.Repository

    @valid_attrs %{avatar: "some avatar", default_branch: "some default_branch", description: "some description", name: "some name", owner: %{}, size: 42, website: "some website"}
    @update_attrs %{avatar: "some updated avatar", default_branch: "some updated default_branch", description: "some updated description", name: "some updated name", owner: %{}, size: 43, website: "some updated website"}
    @invalid_attrs %{avatar: nil, default_branch: nil, description: nil, name: nil, owner: nil, size: nil, website: nil}

    def repository_fixture(attrs \\ %{}) do
      {:ok, repository} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_repository()

      repository
    end

    test "list_repositories/0 returns all repositories" do
      repository = repository_fixture()
      assert Projects.list_repositories() == [repository]
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Projects.get_repository!(repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      assert {:ok, %Repository{} = repository} = Projects.create_repository(@valid_attrs)
      assert repository.avatar == "some avatar"
      assert repository.default_branch == "some default_branch"
      assert repository.description == "some description"
      assert repository.name == "some name"
      assert repository.owner == %{}
      assert repository.size == 42
      assert repository.website == "some website"
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{} = repository} = Projects.update_repository(repository, @update_attrs)
      assert repository.avatar == "some updated avatar"
      assert repository.default_branch == "some updated default_branch"
      assert repository.description == "some updated description"
      assert repository.name == "some updated name"
      assert repository.owner == %{}
      assert repository.size == 43
      assert repository.website == "some updated website"
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_repository(repository, @invalid_attrs)
      assert repository == Projects.get_repository!(repository.id)
    end

    test "delete_repository/1 deletes the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{}} = Projects.delete_repository(repository)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_repository!(repository.id) end
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = Projects.change_repository(repository)
    end
  end
end
