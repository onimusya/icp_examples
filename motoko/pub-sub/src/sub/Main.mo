// Subscriber

import Publisher "canister:pub";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";

actor Subscriber {

  type Counter = {
    topic : Text;
    value : Nat;
  };

  var count: Nat = 0;

  public func init(topic0 : Text) {
    let pubPrincipal = Principal.fromActor(Publisher);
    let subPrincipal = Principal.fromActor(Subscriber);

    Debug.print("[sub][init] pub id:" # Principal.toText(pubPrincipal));
    Debug.print("[sub][init] sub id:" # Principal.toText(subPrincipal));
    Debug.print("[sub][init] topic:" # topic0);

    Publisher.subscribe({
      topic = topic0;
      callback = updateCount;
    });
  };

  public func updateCount(counter : Counter) {
    let subPrincipal = Principal.fromActor(Subscriber);
    Debug.print("[sub][updateCount] sub id:" # Principal.toText(subPrincipal));
    Debug.print("[sub][updateCount] topic:" # counter.topic);
    Debug.print("[sub][updateCount] value:" # Nat.toText(counter.value));
    count += counter.value;
  };

  public query func getCount() : async Nat {
    count;
  };
}
