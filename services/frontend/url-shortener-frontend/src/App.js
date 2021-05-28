import React from 'react';
import './App.css';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
	}

	go = async () => {
    const response = await fetch(
      "http://localhost:4567",
      {
        method: 'PUT',
        mode: 'no-cors'
      }
    )
    //const json = await response.json()
    debugger
	}

  handleSubmit = async (e) => {
    e.preventDefault()
    const response = await fetch(
      "http://localhost:4567",
      {
        method: 'PUT',
        body: JSON.stringify({destination: this.state.destination})
      }
    )
    this.setState({returnedSlug: response.headers.get("Content-Location")})
  }

  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <span>{this.state.destination}</span>
        <span>{this.state.returnedSlug}</span>

        <form onSubmit={this.handleSubmit}>
          <input
            type='text'
            name='target_url'
            onChange={e => this.setState({destination: e.target.value})}
          />
          <button type="submit">Submit</button>
        </form>
      </div>
    );
  }
}

export default App;
