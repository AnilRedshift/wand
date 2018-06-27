defmodule Wand.Test.Helpers.WandFile do
  import Mox
  alias Wand.WandFile

  def stub_empty() do
    contents = %WandFile{} |> Poison.encode!()
    expect(Wand.FileMock, :read, fn _path -> {:ok, contents} end)
  end

  def stub_save(file) do
    contents = file |> Poison.encode!()
    expect(Wand.FileMock, :write, fn _path, ^contents -> :ok end)
  end

  def stub_no_file(reason \\ :enoent) do
    expect(Wand.FileMock, :read, fn _path -> {:error, reason} end)
  end

  def stub_invalid_file() do
    expect(Wand.FileMock, :read, fn _path -> {:ok, "[ NOT VALID JSON"} end)
  end

  def stub_file_wrong_dependencies() do
    contents = %{
      version: "1.0.0",
      dependencies: "not requirements",
    }
    |> Poison.encode!()
    expect(Wand.FileMock, :read, fn _path -> {:ok, contents} end)
  end

  def stub_file_wrong_version(version) do
    contents = %{
      version: version,
      requirements: [],
    }
    |> Poison.encode!()
    expect(Wand.FileMock, :read, fn _path -> {:ok, contents} end)
  end

  def stub_file_missing_version() do
    contents = %{
      requirements: []
    }
    |> Poison.encode!()
    expect(Wand.FileMock, :read, fn _path -> {:ok, contents} end)
  end
end
