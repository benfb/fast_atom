defmodule FastAtom do
  @moduledoc """
  Parse Atom quickly using a Rust NIF.
  """

  defmodule Native do
    @moduledoc false
    use Rustler, otp_app: :fast_atom, crate: "fastatom"

    # When your NIF is loaded, it will override this function.
    def parse(_a), do: :erlang.nif_error(:nif_not_loaded)
  end

  @doc """
  Parse an Atom string into a map.
  """
  @spec parse(String.t()) :: {:ok, map()} | {:error, String.t()}
  def parse(""), do: {:error, "Cannot parse blank string"}

  def parse(atom_string) when is_binary(atom_string) do
    atom_string
    |> Native.parse()
    |> map_to_tuple()
  end

  def parse(_somethig_else), do: {:error, "Atom feed must be passed in as a string"}

  defp map_to_tuple(%{"Ok" => map}), do: {:ok, map}
  defp map_to_tuple({:ok, map}), do: {:ok, map}
  defp map_to_tuple(%{"Err" => msg}), do: {:error, msg}
  defp map_to_tuple({:error, msg}), do: {:error, msg}
end
