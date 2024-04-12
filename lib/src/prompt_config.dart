/// Special prompt config for each request
class PromptConfig {
  /// model engine
  final String engine;
  final double? temperature;
  final double? topP;
  final double? frequencyPenalty;
  final double? presencePenalty;
  final int? n;
  final bool? stream;
  final bool logProbs;
  final bool? echo;
  final int? maxTokens;
  final int? logprobs;
  final int? bestOf;
  final Map<String, dynamic>? logitBias;
  final String? user;
  final int? seed;
  final List<String>? stop;
  final int? topLogprobs;
  final List<Map<String, dynamic>>? tools;
  final dynamic toolChoice;

  PromptConfig({
    required this.engine,
    this.temperature,
    this.topP,
    this.frequencyPenalty,
    this.presencePenalty,
    this.n,
    this.stream,
    this.logProbs = false,
    this.echo,
    this.maxTokens,
    this.logprobs,
    this.bestOf,
    this.logitBias,
    this.user,
    this.seed,
    this.stop,
    this.topLogprobs,
    this.tools,
    this.toolChoice,
  });
}

class GPT4Config extends PromptConfig {
  GPT4Config({
    super.engine = 'gpt-4-1106-preview',
    super.temperature,
    super.topP,
    super.frequencyPenalty,
    super.presencePenalty,
    super.n,
    super.stream,
    super.logProbs,
    super.echo,
    super.maxTokens = 4096,
    super.logprobs,
    super.bestOf,
    super.logitBias,
    super.user,
    super.seed,
    super.stop,
    super.toolChoice,
    super.tools,
    super.topLogprobs,
  });
}

class DefaultClaudeConfig extends PromptConfig {
  DefaultClaudeConfig({
    super.engine = 'claude-3-opus-20240229',
    super.temperature,
    super.topP,
    super.frequencyPenalty,
    super.presencePenalty,
    super.n,
    super.stream,
    super.logProbs,
    super.echo,
    super.maxTokens = 4096,
    super.logprobs,
    super.bestOf,
    super.logitBias,
    super.user,
    super.seed,
    super.stop,
    super.toolChoice,
    super.tools,
    super.topLogprobs,
  });
}
