use rustler::{Encoder, Env, NifResult, Term};
use serde_json::json;

mod atoms {
    rustler::atoms! {
        ok,
        error,
    }
}

rustler::init!("Elixir.FastAtom.Native", [parse]);

#[rustler::nif(schedule = "DirtyCpu")]
fn parse(env: Env, atom_string: String) -> NifResult<Term> {
    let channel = atom_syndication::Feed::read_from(atom_string.as_bytes())
        .map_err(|err| format!("Unable to parse Atom - ({:?})", err));

    let ser = serde_rustler::Serializer::from(env);
    let de = json!(channel);

    let encoded =
        serde_transcode::transcode(de, ser).map_err(|_err| "Unable to encode to erlang terms");

    match encoded {
        Ok(term) => Ok(term),
        Err(error_message) => Ok((atoms::error(), error_message).encode(env)),
    }
}
