// THIS FILE IS GENERATED AUTOMATICALLY. DO NOT MODIFY.
import { Registry } from '@cosmjs/proto-signing'

import {
    plugEnv,
    plugKeplr,
    plugSigner,
    plugWebSocket,
    Env
} from '@ignt/plugins'
{{ range .Modules }}import { Module as {{ camelCaseUpperSta .Pkg.Name }}, msgTypes as {{ camelCaseUpperSta .Pkg.Name }}MsgTypes } from './{{ .Pkg.Name }}'
{{ end }}

const registry = new Registry([
  {{ range .Modules }}...{{ camelCaseUpperSta .Pkg.Name }}MsgTypes,
  {{ end }}
])

{{ range .Modules }}
function plug{{ camelCaseUpperSta .Pkg.Name }}(env: Env): {
    {{ camelCaseLowerSta .Pkg.Name }}: {{ camelCaseUpperSta .Pkg.Name }}
} {
    return {
        {{ camelCaseLowerSta .Pkg.Name }}: new {{ camelCaseUpperSta .Pkg.Name }}(env.apiURL)
    }
}
{{ end }}

type {{ capitalCase .Repo }} = {{ range .Modules }}ReturnType<typeof plug{{ camelCaseUpperSta .Pkg.Name }}> & {{ end }}
ReturnType<typeof plugSigner> &
ReturnType<typeof plugKeplr> &
ReturnType<typeof plugWebSocket> &
ReturnType<typeof plugEnv>

function create{{ capitalCase .Repo }}(p: { env: Env }) {
    return _use({

    {{ range .Modules }}
        ...plug{{ camelCaseUpperSta .Pkg.Name }}(p.env),
    {{ end }}
        ...plugSigner(),

        ...plugKeplr(),

        ...plugWebSocket(p.env),

        ...plugEnv(p.env)

    })
}

function _use<T>(elements: T): { [K in keyof T]: T[K] } {
    return Object.assign({}, elements)
}

export {
    {{ range .Modules }}
        plug{{ camelCaseUpperSta .Pkg.Name }},
    {{ end }}
    create{{ capitalCase .Repo }},
    registry,
    {{ capitalCase .Repo }},
    _use
}
