# encoding: utf-8

module AgileNotifier
  class Composer
    SENTENCES = {
        de: [
                "%{committer_name} hat den Build kaputt gemacht.",
                "Schießt %{committer_name} mit der Nerf Gun ab!",
                "%{committer_name} hat Scheiße gebaut."
            ],
        en: [
                "%{committer_name} has broken the build.",
                "%{committer_name} fucked up the build.",
                "What the fucking code has %{committer_name} pushed!"
            ],
        zh: [
                "%{committer_name}在搞毛啊, 构建失败了!",
                "%{committer_name}提交的什么烂代码啊?",
                "请注意, %{committer_name}在搞破坏."
            ]
    }

    class << self
      def blame_committer_of_a_commit(args)
        repo = args[:repo]
        revision = args[:revision] || args[:build].revision
        language = args[:language]
        committer_name = repo.get_committer_name_of_a_commit(revision)
        blame_committer(committer_name, language)
      end

      def blame_committer(committer_name, language)
        random_picker(SENTENCES[language]).gsub(/%\{committer_name\}/, committer_name)
      end

      def random_picker(list)
        random_number = rand(list.size)
        list[random_number]
      end
    end

    private_class_method :random_picker
  end
end
