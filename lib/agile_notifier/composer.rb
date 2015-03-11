# encoding: utf-8

module AgileNotifier
  class Composer
    SENTENCES_BLAME_COMMITTER = {
      de: [
        "%{committer_name} hat den Build kaputt gemacht.",
        "Schießt %{committer_name} mit der Nerf Gun ab!",
        "%{committer_name} hat Scheiße gebaut.",
        "Hilfe! Hilfe! %{committer_name} versucht mich zu töten!"
      ],
      en: [
        "%{committer_name} has broken the build.",
        "%{committer_name} fucked up the build.",
        "What the fucking code has %{committer_name} pushed!"
      ],
      es: [
        "%{committer_name} ha destruido la compilacion",
        "que clase de codigo esta escribiendo %{committer_name} ? ",
        "tal vez es mejor que %{committer_name} se dedique a otra cosa..."
      ],
      zh: [
        "%{committer_name}在搞毛啊, 构建失败了!",
        "%{committer_name}提交的什么烂代码啊?",
        "请注意, %{committer_name}在搞破坏."
      ]
    }
    
    SENTENCES_WARN_COMMITTER = {
      de: [
        "%{committer_name} hat den Build krank gemacht.",
        "%{committer_name} hat etwas nicht gut genug gemacht."
      ],
      en: [
        "%{committer_name} has made the build sick.",
        "%{committer_name} has done something not so good."
      ],
      es: [
        "%{committer_name} ha hecho a los enfermos de generación.",
        "%{committer_name} ha hecho algo malo."
      ],
      zh: [
        "%{committer_name}让构建生病了.",
        "%{committer_name}做了一件不太光荣的事."
      ]
    }

    SENTENCES_PRAISE_COMMITTER = {
      de: [
        "%{committer_name} hat den Build gefixt!",
        "%{committer_name} ist ein Genie!",
        "%{committer_name} hat die Welt gerettet!"
      ],
      en: [
        "%{committer_name} has fixed the build.",
        "%{committer_name} is super brilliant!",
        "%{committer_name} saved the world.",
        "%{committer_name} roundhouse kicked chuck norris' butt"
      ],
      es: [
        "%{committer_name} ha reparado la compilacion",
        "%{committer_name} es un genio!",
        "%{committer_name} es el mejor programador de la historia!"
      ],
      zh: [
        "%{committer_name}很厉害啊, 修复了构建.",
        "%{committer_name}是个好同志, 该涨工资了.",
        "%{committer_name}是当代活雷锋啊!"
      ]
    }

    SENTENCES_WARN_WIP_LIMIT = {
        de: [
            "Kanban WIP übersteigt das Limit.",
            "Kanban hat einen Flaschenhals.",
            "Kanban hat zu viele Tickets, arbeitet jemand schon daran?"
        ],
        en: [
            "Kanban WIP exceeds limit.",
            "Kanban has hit a bottleneck.",
            "Kanban has stacked too many items, is anyone working on it?"
        ],
        es: [
            "El limite de WIP ha sido excedido.",
            "El Kanban se esta llenando mucho.",
            "Hay demasiados elementos Kanban, alguien esta trabajando en el?"
        ],
        zh: [
            "看板瓶颈上限超出",
            "搞什么呢? 看板堆积太多工作了, 想被炒鱿鱼吗?",
            "看板, 嘟嘟, 请注意. 看板, 嘟嘟, 请注意."
        ]
    }

    class << self
      def warn_wip_limit(args)
        random_picker(SENTENCES_WARN_WIP_LIMIT[args[:language]])
      end

      def blame_committer_of_a_commit(args)
        committer_name = get_committer_name_of_a_commit(args)
        blame_committer(committer_name, args[:language])
      end
      
      def warn_committer_of_a_commit(args)
        committer_name = get_committer_name_of_a_commit(args)
        warn_committer(committer_name, args[:language])
      end

      def praise_committer_of_a_commit(args)
        committer_name = get_committer_name_of_a_commit(args)
        praise_committer(committer_name, args[:language])
      end

      def get_committer_name_of_a_commit(args)
        repo = args[:repo]
        revision = args[:build].nil? ? args[:revision] : args[:build].revision
        if revision
          repo.get_committer_name_of_a_commit(revision)
        else
          'Someone'
        end
      end

      def blame_committer(committer_name, language)
        mention_committer(committer_name, SENTENCES_BLAME_COMMITTER[language])
      end
      
      def warn_committer(committer_name, language)
        mention_committer(committer_name, SENTENCES_WARN_COMMITTER[language])
      end

      def praise_committer(committer_name, language)
        mention_committer(committer_name, SENTENCES_PRAISE_COMMITTER[language])
      end

      def mention_committer(committer_name, sentences)
        sentence = random_picker(sentences)
        sentence.gsub(/%\{committer_name\}/, committer_name)
      end

      def random_picker(list)
        random_number = rand(list.size)
        list[random_number]
      end
    end

    private_class_method :get_committer_name_of_a_commit, :blame_committer, :warn_committer, :praise_committer, :mention_committer, :random_picker
  end
end
