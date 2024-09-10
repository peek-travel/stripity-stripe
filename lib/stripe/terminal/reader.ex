defmodule Stripe.Terminal.Reader do
  @moduledoc """
  A Reader represents a physical device for accepting payment details

  This redefines the Stripe.Terminal.Reader module to add additional functions for processing payments and refunds on a reader.
  We need to redefine this module bercause the original struct also needs to change and include "action" key.

  You can:
  - [Create a Reader](https://stripe.com/docs/api/terminal/readers/create)
  - [Retrieve a Reader](https://stripe.com/docs/api/terminal/readers/retrieve)
  - [Update a Reader](https://stripe.com/docs/api/terminal/readers/update)
  - [Delete a Reader](https://stripe.com/docs/api/terminal/readers/delete)
  - [List all Readers](https://stripe.com/docs/api/terminal/readers/list)
  - [Process a payment intent](https://stripe.com/docs/api/terminal/readers/process_payment_intent)
  - [Refund a payment intent](https://stripe.com/docs/api/terminal/readers/refund_payment)
  - [Cancel a reader action](https://stripe.com/docs/api/terminal/readers/cancel_action)
  - [Present a payment method for testing purposes](https://stripe.com/docs/api/terminal/readers/present_payment_method)
  """

  use Stripe.Entity

  import Stripe.Request

  require Stripe.Util

  @type t :: %__MODULE__{
          id: Stripe.id(),
          device_type: String.t(),
          label: String.t(),
          action: map(),
          location: String.t(),
          metadata: Stripe.Types.metadata(),
          serial_number: String.t(),
          status: String.t(),
          object: String.t(),
          device_sw_version: String.t(),
          ip_address: String.t(),
          livemode: boolean()
        }

  defstruct [
    :id,
    :device_type,
    :label,
    :location,
    :action,
    :metadata,
    :serial_number,
    :status,
    :object,
    :device_sw_version,
    :ip_address,
    :livemode
  ]

  @plural_endpoint "terminal/readers"

  @doc """
  Create a new reader
  """
  @spec create(params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params:
               %{
                 :registration_code => String.t(),
                 optional(:label) => String.t(),
                 optional(:location) => Stripe.id(),
                 optional(:metadata) => Stripe.Types.metadata()
               }
               | %{}

  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Retrieve a reader with a specified `id`.
  """
  @spec retrieve(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a reader.

  Takes the `id` and a map of changes.
  """
  @spec update(Stripe.id() | t, params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:label) => String.t(),
               optional(:metadata) => Stripe.Types.metadata()
             }
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Delete an reader.
  """
  @spec delete(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def delete(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  List all readers.
  """
  @spec list(params, Stripe.options()) :: {:ok, Stripe.List.t(t)} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:device_type) => String.t(),
               optional(:location) => t | Stripe.id(),
               optional(:status) => String.t(),
               optional(:ending_before) => t | Stripe.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | Stripe.id()
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end

  @doc """
  Initiates a payment flow on a Reader
  """
  @spec process_payment_intent(
          reader_id :: String.t(),
          params :: %{
            optional(:payment_intent) => String.t()
          },
          opts :: Keyword.t()
        ) ::
          {:ok, Stripe.Terminal.Reader.t()}
          | {:error, Stripe.ApiErrors.t()}
          | {:error, term()}
  def process_payment_intent(reader_id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(reader_id)}/process_payment_intent")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Initiates a refund on a Reader
  """
  @spec refund_payment(
          reader_id :: String.t(),
          params :: %{
            optional(:amount) => integer(),
            optional(:charge) => String.t(),
            optional(:metadata) => %{optional(String.t()) => String.t()},
            optional(:payment_intent) => String.t(),
            optional(:refund_application_fee) => boolean(),
            optional(:reverse_transfer) => boolean()
          },
          opts :: Keyword.t()
        ) ::
          {:ok, Stripe.Terminal.Reader.t()}
          | {:error, Stripe.ApiErrors.t()}
          | {:error, term()}
  def refund_payment(reader_id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(reader_id)}/refund_payment")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Cancels the current reader action
  """
  @spec cancel_action(
          reader_id :: String.t(),
          params :: %{},
          opts :: Keyword.t()
        ) ::
          {:ok, Stripe.Terminal.Reader.t()}
          | {:error, Stripe.ApiErrors.t()}
          | {:error, term()}
  def cancel_action(reader_id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(reader_id)}/cancel_action")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Presents a payment method on a simulated reader. Can be used to simulate accepting a payment, saving a card or refunding a transaction.
  """
  @spec present_payment_method(
          reader_id :: String.t(),
          params :: %{
            optional(:card_present) => %{optional(:number) => String.t()},
            optional(:interac_present) => %{optional(:number) => String.t()},
            optional(:type) => :card_present | :interac_present
          },
          opts :: Keyword.t()
        ) ::
          {:ok, Stripe.Terminal.Reader.t()}
          | {:error, Stripe.ApiErrors.t()}
          | {:error, term()}
  def present_payment_method(reader_id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint("test_helpers/terminal/readers/#{get_id!(reader_id)}/present_payment_method")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end
end
