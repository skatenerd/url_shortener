import React from 'react';
import './App.css';
import { getSlug } from './api';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  handleSubmit = async (e) => {
    e.preventDefault()
    const response = await getSlug(this.state.destination)
    if(response.ok) {
      this.setState({
        returnedURL: response.headers.get("Content-Location"),
        errorMessage: null
      })
    } else {
      const errorMessage = await response.text()
      this.setState({
        errorMessage: errorMessage,
        returnedURL: null
      })
    }

  }

  render() {
    return (
      <div>
        <div className='instructions'>
          <span>Please Enter the desired URL</span>
        </div>
        {this.state.errorMessage &&
          <span data-testid="error_message">{this.state.errorMessage}</span>
        }
        {this.state.returnedURL &&
          <a data-testid='short_url' href={this.state.returnedURL}>{this.state.returnedURL}</a>
        }

        <div className='form_wrapper'>
          <form onSubmit={this.handleSubmit}>
            <label htmlFor="target_url">URL</label>
            <input
              type='text'
              name='target_url'
              id='target_url'
              onChange={e => this.setState({destination: e.target.value})}
            />
            <button type="submit">Submit</button>
          </form>
        </div>
      </div>
    );
  }
}

export default App;
