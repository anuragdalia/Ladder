defmodule Ladder do
  @moduledoc """
  ## Sample Task list
      task_list = %{
            task1: {Ladder.TestHelper, :task_exec, [1]},
            task2: {Ladder.TestHelper, :task_exec, [2], [4, 6, 8]},
            task3: {Ladder.TestHelper, :task_exec, [:ladder_resp]},
            task4: {Ladder.TestHelper, :task_exec, [4]},
            task5: {Ladder.TestHelper, :task_exec, [5]},
            task6: {Ladder.TestHelper, :task_exec, [6]},
            task7: {Ladder.TestHelper, :task_exec, [7]},
            task8: {Ladder.TestHelper, :task_exec, [8]}
          }

  fourth element in the task tuple is optional and can contain the positive outcomes of task
  the children tasks will only be executed if the result of this task matches one of the values in this list

  ## Sample rule
      rule = %{
        task1: %{
          task6: :task8,
        },
        task4: :task5,
        task2: [:task7, :task3]
      }

  ## To execute:
      Ladder.climb(task_list, rule)
  """

  def run(task_list, rule) when is_map(rule)  do
    Pmap.map(
      rule,
      fn {k, v} ->

        {resp, status} = special_apply(task_list[k], nil)



        cond  do
          status == :response_unacceptable -> {k, resp, :not_running_children}
          status in [:accepted_result, :accepted_no_check] ->
            cond do
              is_map(v) ->
                {k, resp, run(task_list, v)}
              is_list(v) ->
                {
                  k,
                  resp,
                  Pmap.map(
                    v,
                    &task_list[&1]
                     |> special_apply(resp)
                     |> Tuple.insert_at(0, &1)
                  )
                }
              is_atom(v) ->
                {
                  k,
                  resp,
                  task_list[v]
                  |> special_apply(resp)
                  |> Tuple.insert_at(0, v)
                }
            end
        end
      end
    )
  end

  defp special_apply(task_tuple, previous_response) do
    cond do
      task_tuple == nil -> {:unknown_job, false}
      tuple_size(task_tuple) in [3, 4] ->
        arguments = elem(task_tuple, 2)
        arguments = Enum.map(
          arguments,
          fn arg ->
            case arg  do
              :ladder_resp -> previous_response
              :current_time_milliseconds -> :os.system_time(:millisecond)
              :current_time_seconds -> :os.system_time(:second)
              _ -> arg
            end
          end
        )
        resp = apply(elem(task_tuple, 0), elem(task_tuple, 1), arguments)

        childeren_status = cond do
          tuple_size(task_tuple) == 3 -> :accepted_no_check
          resp in elem(task_tuple, 3) -> :accepted_result
          true -> :response_unacceptable
        end



        {resp, childeren_status}
      true -> raise "Job declaration is wrong"
    end
  end


end
