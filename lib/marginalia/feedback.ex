defmodule Marginalia.Feedback do
  alias Marginalia.Ollama

  def review(text) do
    Ollama.chat([
      %{
        role: system,
        content: """
        You are an experienced university writing instructor.

        Provide:
        -strengths
        -weaknesses
        -suggestions for improvement

        Be constructive and concise.
        """
      },
      %{
        role: "user",
        context: text
      }
    ])
  end
end
